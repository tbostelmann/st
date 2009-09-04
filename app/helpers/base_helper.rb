module BaseHelper

  # Static data to drive the upper-left "triptych" of They Save/You Match/We Prosper
  # This remains.
  unless defined?(TRIPTYCH_PANELS)
    ::TRIPTYCH_PANELS = [
      OpenStruct.new(
        :image       => "graphics/1.jpg",
        :alt_tag     => "They Save",
        :summary     => "For the things that matter most.",
        :description => "A qualified individual or family works hard to save for a goal."),
      OpenStruct.new(
        :image       => "graphics/2.jpg",
        :alt_tag     => "You Match",
        :summary     => "Then your match is matched again.",
        :description => "You match someone's goal and your donation is matched again by a matched savings program."),
      OpenStruct.new(
        :image       => "graphics/3.jpg",
        :alt_tag     => "Together, We Prosper",
        :summary     => "Invest in a poverty-free future.",
        :description => "By helping working people who are already helping themselves, we break the poverty cycle and create economic stability for all.")
    ]
  end
  
  # Static data this is a mock of anticipated results from a Saver.random_successful_saver query.
  # THIS SHOULD BE REMOVED.
  unless defined?(RANDOM_SUCCESSFUL_SAVER)
    ::RANDOM_SUCCESSFUL_SAVER =
      OpenStruct.new(
        :display_name     => "Gilma",
        :avatar_photo_url => "thumbnails/gilma.png",
        :summary          => "Through hard work and dedication and access to a matched-savings program, Gilma saved to become the first in her family to graduate from college."
    )
  end
  
  # Static data this is a mock of anticipated results from a Organization.find_by_founding_partners query.
  # THIS SHOULD BE REMOVED.
  unless defined?(ORGANIZATION_BY_FOUNDING_PARTNERS)
    ::ORGANIZATION_BY_FOUNDING_PARTNERS = [
      OpenStruct.new(
        :display_name      => "CFED",
        :organization_path => "http://www.cfed.org"),
      OpenStruct.new(
        :display_name      => "American Dream Match Fund",
        :organization_path => "http://americandreammatchfund.org"),
      OpenStruct.new(
        :display_name      => "EARN",
        :organization_path => "http://www.earn.org"),
      OpenStruct.new(
        :display_name      => "JUMA Ventures",
        :organization_path => "http://www.jumaventures.org"),
      OpenStruct.new(
        :display_name      => "Opportunity Fund",
        :organization_path => "http://www.opportunityfund.org")
    ]
  end
  
  # Static data this is a mock of anticipated results from a Organization.find_by_supporters query.
  # THIS SHOULD BE REMOVED.
  unless defined?(ORGANIZATION_BY_SUPPORTERS)
    ::ORGANIZATION_BY_SUPPORTERS = [
      OpenStruct.new(
        :display_name      => "Silicon Valley Community Foundation",
        :organization_path => "http://www.siliconvalleycf.org"),
      OpenStruct.new(
        :display_name      => "Marin Community Foundation",
        :organization_path => "http://www.marincf.org"),
      OpenStruct.new(
        :display_name      => "San Francisco Foundation",
        :organization_path => "http://www.sff.org"),
      OpenStruct.new(
        :display_name      => "United Way of the Bay Area",
        :organization_path => "http://www.uwba.org"),
      OpenStruct.new(
        :display_name      => "Haas Sr. Fund",
        :organization_path => "http://www.haassr.org")
    ]
  end

end
