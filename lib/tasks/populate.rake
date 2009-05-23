namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller'
    require 'action_controller/test_process.rb'

    us = Country.find(:first, :conditions => {:name => "United States"})

    wa = State.find(:first, :conditions => {:name => "WA"})
    ca = State.find(:first, :conditions => {:name => "CA"})
    ma = State.find(:first, :conditions => {:name => "MA"})

    sanfran = MetroArea.find(:first, :conditions => {:name => 'San Francisco'})
    seattle = MetroArea.find(:first, :conditions => {:name => 'Seattle'})
    lawrence = MetroArea.find(:first, :conditions => {:name => 'Lawrence'})
    sanjose = MetroArea.find(:first, :conditions => {:name => 'San Jose'})

    Education = AssetType.find(:first, :conditions=> {:asset_name=>'Education'})
    Home = AssetType.find(:first, :conditions=>{:asset_name => "Home"})
    Business = AssetType.find(:first, :conditions=>{:asset_name => "Business"})

    stOrg = Organization.find(:first, :conditions => {:full_name => 'SaveTogether'})

    admin = User.create!(
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

    org = Organization.create!(
      :full_name => 'Washington CASH',
      :login => "washingtoncash",
      :email => "washingtoncash@example.com",
      :description => "<p>Washington CASH description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member])
    org.activate
    saver = Saver.create!(
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
      :organization => org,
      :asset_type => Home,
      :requested_match_cents => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Washington CASH Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/WACASH_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :full_name => 'EARN',
      :login => "earn_login",
      :email => "earn@example.com",
      :description => "<p>EARN description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanfran,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member])
    org.activate
    saver = Saver.create!(
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
      :organization => org,
      :asset_type => Education,
      :requested_match_cents => "2000")
    saver.activate
    photo = Photo.new(
            :name => "EARN Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/EARN_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :full_name => 'Opportunity Fund',
      :login => "opportunityfund",
      :email => "opportunityfund@example.com",
      :description => "Opportunity Fund description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanjose,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member])
    org.activate
    saver = Saver.create!(
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
      :organization => org,
      :asset_type => Business,
      :requested_match_cents => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Opportunity Fund Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/Opportunity_saver1.jpg", 'image/jpg'))
    photo.user = saver
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :full_name => 'Lawrence Community Works',
      :login => "lawrencecomworks",
      :email => "lawrencecommunityworks@example.com",
      :description => "Lawrence Community Works description",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ma,
      :metro_area => lawrence,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member])
    org.activate
    saver = Saver.create!(
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
      :organization => org,
      :asset_type => Business,
      :requested_match_cents => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Lawrence Community Works Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/LCW_saver_1.JPG", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

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
