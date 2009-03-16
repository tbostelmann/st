namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller'
    require 'action_controller/test_process.rb'

    file = "#{RAILS_ROOT}/test/files/WACASH_logo.png"
    mimetype = 'image/png'
    org = Organization.create(
            :phone => "206-352-1945",
            :web_site_url => "http://www.washingtoncash.org/"
    )
    profile = Profile.create(
      :first_name => "Washington CASH",
      :statement => "Washington Community Alliance for Self Help (CASH) is a microenterprise development organization that provides low income women, people with disabilities and other underserved individuals access to capital and business development training.",
      :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
      :profiled => org
    )
    address = Address.create(
        :line1 => "2100 24th Avenue South",
        :line2 => "Suite 380",
        :city => "Seattle",
        :state => "WA",
        :zip => "98144",
        :addressable => org    
    )
    file = "#{RAILS_ROOT}/test/files/WACASH_saver1.jpg"
    mimetype = 'image/jpg'
    beneficiary = Beneficiary.create(:organization => org)
    Account.create(:owner => beneficiary)
    profile = Profile.create(
            :first_name => "Samantha",
            :last_name => "Smith",
            :statement => "Samantha is saving to open her own framing business.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => beneficiary    
            )
    group_member = GroupMember.create(
      :beneficiary => beneficiary,
      :group => Group.create(
        :name => "Class of Spring 2009",
        :organization => org
      )
    )

    file = "#{RAILS_ROOT}/test/files/EARN_logo.gif"
    mimetype = 'image/gif'
    org = Organization.create(
            :phone => "206-555-1212",
            :web_site_url => "http://www.sfearn.org/"
    )
    profile = Profile.create(
            :first_name => "EARN",
            :statement => "EARN breaks the cycle of poverty by matching the savings of low-wage workers and helping them invest in assets that build wealth, creating a cycle of prosperity across generations.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => org
    )
    address = Address.create(
            :line1 => "235 Montgomery Street",
            :line2 => "Suite 300",
            :city => "San Francisco",
            :state => "CA",
            :zip => "94104",
            :addressable => org
    )
    file = "#{RAILS_ROOT}/test/files/EARN_saver1.jpg"
    mimetype = 'image/jpg'
    beneficiary = Beneficiary.create(:organization => org)
    Account.create(:owner => beneficiary)
    profile = Profile.create(
            :first_name => "Juanita",
            :last_name => "Jones",
            :statement => "Emily is saving to purchase a townhome.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => beneficiary
            )
    group_member = GroupMember.create(
      :beneficiary => beneficiary,
      :group => Group.create(
        :name => "Bay Area Homeowners Winter 2008",
        :organization => org
      )
    )

    file = "#{RAILS_ROOT}/test/files/Opportunity_logo.gif"
    mimetype = 'image/gif'
    org = Organization.create(
            :phone => "206-555-1212",
            :web_site_url => "http://www.opportunityfund.org/"
    )
    profile = Profile.create(
            :first_name => "Opportunity Fund",
            :statement => "Opportunity Fund advances the economic well-being of working people by helping them earn, save, and invest in their future.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => org
    )
    address = Address.create(
            :line1 => "111 W. St. John Street",
            :line2 => "Suite 800",
            :city => "San Jose",
            :state => "CA",
            :zip => "95113",
            :addressable => org
    )
    file = "#{RAILS_ROOT}/test/files/Opportunity_saver1.jpg"
    mimetype = 'image/jpg'
    beneficiary = Beneficiary.create(:organization => org)
    Account.create(:owner => beneficiary)
    profile = Profile.create(
            :first_name => "Rosie",
            :last_name => "Alvarez",
            :statement => "Rosie is saving to open her own produce stand at the local public market.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => beneficiary
            )
    group_member = GroupMember.create(
      :beneficiary => beneficiary,
      :group => Group.create(
        :name => "Bay Area Homeowners Winter 2008",
        :organization => org
      )
    )

    file = "#{RAILS_ROOT}/test/files/LCW_logo.JPG"
    mimetype = 'image/jpg'
    org = Organization.create(
            :phone => "206-555-1212",
            :web_site_url => "http://www.kcworks.org/"
    )
    profile = Profile.create(
            :first_name => "Lawrence Community Works",
            :statement => "Lawrence CommunityWorks (LCW) is a nonprofit community development corporation working to transform and revitalize the physical, economic, and social landscape of Lawrence with a growing network of residents and stakeholders who are building family and community assets, providing each other with caring and mutual support, building leadership and civic engagement skills, and engaging in collective action for positive growth and change in Lawrence.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => org
    )
    address = Address.create(
            :line1 => "166-168 Newberry Street",
            :city => "Lawrence",
            :state => "MA",
            :zip => "01841",
            :addressable => org
    )
    file = "#{RAILS_ROOT}/test/files/LCW_saver_1.JPG"
    mimetype = 'image/jpg'
    beneficiary = Beneficiary.create(:organization => org)
    Account.create(:owner => beneficiary)
    profile = Profile.create(
            :first_name => "Sonja",
            :last_name => "Johnson",
            :statement => "Sonja is saving to open her own produce stand at the local public market.",
            :photo => Photo.new(:uploaded_data => ActionController::TestUploadedFile.new(file, mimetype)),
            :profiled => beneficiary
            )
    group_member = GroupMember.create(
      :beneficiary => beneficiary,
      :group => Group.create(
        :name => "Fall 2008 Microentrepreneurs",
        :organization => org
      )
    )
    
#    [Category, Product, Person].each(&:delete_all)
#    
#      category.name = Populator.words(1..3).titleize
#      Product.populate 10..100 do |product|
#        product.category_id = category.id
#        product.name = Populator.words(1..5).titleize
#        product.description = Populator.sentences(2..10)
#        product.price = [4.99, 19.95, 100]
#        product.created_at = 2.years.ago..Time.now
#      end
#    end
#    
#    Person.populate 100 do |person|
#      person.name    = Faker::Name.name
#      person.company = Faker::Company.name
#      person.email   = Faker::Internet.email
#      person.phone   = Faker::PhoneNumber.phone_number
#      person.street  = Faker::Address.street_address
#      person.city    = Faker::Address.city
#      person.state   = Faker::Address.us_state_abbr
#      person.zip     = Faker::Address.zip_code
#    end
  end
end