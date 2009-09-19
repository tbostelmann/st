class BaseController < ApplicationController
  def site_index
    @successful_savers = Saver.find_successful_savers(:all, :limit => 5)
    @featured_savers  = Saver.find_random(:all, :limit => 3)
    @partner_list     = random_partner_list
    @featured_donors   = Donor.find_featured_donor(3)

    # DPIRONE: note this does a lot of extra work to get CE meta data that we presently don't use,
    # so commenting out to save CPU cycles ...
    # respond_to do |format|
      # format.html { get_additional_homepage_data }
    # end
  end

protected

  def random_partner_list
    founders = random_truth?
    [OpenStruct.new(
      :partners_kind => "Founding Partners",
      :partners      => ORGANIZATION_FIND_BY_FOUNDING_PARTNERS
    ),
     OpenStruct.new(
      :partners_kind => "Supporters",
      :partners      => ORGANIZATION_FIND_BY_SUPPORTERS
    )]
  end
  
  def random_truth?
    # rand(2) returns a psuedorandom integer >= 0 and less than max=2 (in this case), i.e 0 or 1
    # See Kernel.rand, Pickaxe book, pg. 527.
    rand(2) == 1
  end

end
