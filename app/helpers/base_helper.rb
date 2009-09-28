module BaseHelper

  # Static data this is a mock of anticipated results from a Organization.find_by_founding_partners query.
  # THIS SHOULD BE REMOVED.
  unless defined?(ORGANIZATION_FIND_BY_FOUNDING_PARTNERS)
    ::ORGANIZATION_FIND_BY_FOUNDING_PARTNERS = [
      OpenStruct.new(
        :display_name      => "CFED / American Dream Match Fund",
        :organization_path => "http://www.savetogether.org/organizations/74"),
      OpenStruct.new(
        :display_name      => "EARN",
        :organization_path => "http://www.savetogether.org/organizations/7"),
      OpenStruct.new(
        :display_name      => "JUMA Ventures",
        :organization_path => "http://www.savetogether.org/organizations/61"),
      OpenStruct.new(
        :display_name      => "Opportunity Fund",
        :organization_path => "http://www.savetogether.org/organizations/5")
    ]
  end
  
  # Static data this is a mock of anticipated results from a Organization.find_by_supporters query.
  # THIS SHOULD BE REMOVED.
  unless defined?(ORGANIZATION_FIND_BY_SUPPORTERS)
    ::ORGANIZATION_FIND_BY_SUPPORTERS = [
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
