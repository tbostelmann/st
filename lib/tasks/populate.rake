namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller'
    require 'action_controller/test_process.rb'

    MetroArea.destroy_all
    State.destroy_all
    Country.destroy_all
    us = Country.create(:name => "United States")

    wa = State.create(:name => "WA")
    ca = State.create(:name => "CA")
    ma = State.create(:name => "MA")

    sanfran = MetroArea.create(:name => 'San Francisco', :state => ca, :country => us)
    seattle = MetroArea.create(:name => 'Seattle', :state => wa, :country => us)
    lawrence = MetroArea.create(:name => 'Lawrence', :state => ma, :country => us)
    sanjose = MetroArea.create(:name => 'San Jose', :state => ca, :country => us)

    education = AssetType.create :asset_name => "Education"
    home = AssetType.create :asset_name => "Home"
    business = AssetType.create :asset_name => "Business"

    stOrg = Organization.create(:name => 'SaveTogether')
    account = Account.create(:owner => stOrg)

    org = Organization.create(:name => 'Washington CASH')
    account = Account.create(:owner => org)
    saver = User.create(
      :login => "samantha",
      :email => "samantha@example.com",
      :description => "<p>Samantha is saving for a downpayment towards a house. Samantha's dream is to own her own home. She is saving to provide a home for her 2 children. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Samantha was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,      
      :role => Role[:member],
      :saver => true)
    saver.activate
    photo = Photo.new(
            :name => "Washington CASH Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/WACASH_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save
    saverCase = AssetDevelopmentCase.create(
            :user => saver,
            :asset_type => home,
            :requested_match_total => "2000",
            :requested_match_left => "500",
            :organization => org)
    account = Account.create(:owner => saverCase)

    org = Organization.create(:name => 'EARN')
    account = Account.create(:owner => org)
    saver = User.create(
      :login => "juanita",
      :email => "juanita@example.com",
      :description => "<p>Juana's dream is to get a nursing degree and work in an emergency room. She is saving to enroll at the City College of San Francisco School of Nursing. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Juana was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanfran,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
    photo = Photo.new(
            :name => "EARN Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/EARN_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save
    saverCase = AssetDevelopmentCase.create(
            :user => saver,
            :asset_type => education,
            :requested_match_total => "2000",
            :requested_match_left => "700",
            :organization => org)
    account = Account.create(:owner => saverCase)


    org = Organization.create(:name => 'Opportunity Fund')
    account = Account.create(:owner => org)
    saver = User.create(
      :login => "rosie",
      :email => "rosie@example.com",
      :description => "Rosie is saving to open her own produce stand at the local public market. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Samantha was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanjose,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
    photo = Photo.new(
            :name => "Opportunity Fund Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/Opportunity_saver1.jpg", 'image/jpg'))
    photo.user = saver
    photo.save
    saver.avatar = photo
    saver.save
    saverCase = AssetDevelopmentCase.create(
            :user => saver,
            :asset_type => business,
            :requested_match_total => "2000",
            :requested_match_left => "1500",
            :organization => org)
    account = Account.create(:owner => saverCase)

    org = Organization.create(:name => 'Lawrence Community Works')
    account = Account.create(:owner => org)
    saver = User.create(
      :login => "sonja",
      :email => "sonja@example.com",
      :description => "Sonja is saving to open her own crafts stand at the local flea market. Sonja is eager to provide a valuable service to the community. She will leverage her considerable strengths in putting together innovative craft projects. She has been helping elementary school children for the past 10 years in after school arts and crafts programs.",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ma,
      :metro_area => lawrence,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
    photo = Photo.new(
            :name => "Lawrence Community Works Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/LCW_saver_1.JPG", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save
    saverCase = AssetDevelopmentCase.create(
            :user => saver,
            :asset_type => business,    
            :requested_match_total => "2000",
            :requested_match_left => "200",
            :organization => org)
    account = Account.create(:owner => saverCase)
  
    admin = User.create(
      :login => "admin",
      :email => "tom@savetogether.org",
      :description => "Person with adminstrator role",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:admin])
    admin.activate

    tbostelmann = User.create(
      :login => "tbostelmann",
      :email => "tbostelmann@gmail.com",
      :description => "Just a developer",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 40.years.ago,
      :activities_count => 0,
      :role => Role[:admin])
    tbostelmann.activate
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
   
   #Link asset development cases to particular asset types
   peopledata = { 1=>{:asset_type_id => '2'}, 2=> {:asset_type_id => '1'}, 3=>{:asset_type_id=> '3'}, 4=>{:asset_type_id=>'3'} }
   AssetDevelopmentCase.update(peopledata.keys,peopledata.values)

   #put in requested match totals and amount left for asset development case examples
   peopledata = { 1=>{:requested_match_total => '2000.00', :requested_match_left=>'500.00'}, 2=>{:requested_match_total=>'1500.00', :requested_match_left=>'10.00'}, 3=>{:requested_match_total=>'1000.00', :requested_match_left=>'325.00'}, 4=>{:requested_match_total=>'600.00', :requested_match_left=>'100.00'}}
   AssetDevelopmentCase.update(peopledata.keys,peopledata.values)

  end
end
