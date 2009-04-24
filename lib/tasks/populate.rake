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

    education = AssetType.find(:first, :conditions => {:asset_name => "education"})
    home = AssetType.find(:first, :conditions => {:asset_name => "home"})
    business = AssetType.find(:first, :conditions => {:asset_name => "business"})

    stOrg = Organization.find(:first, :conditions => {:name => 'SaveTogether'})

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

    org = Organization.create!(:name => 'Washington CASH')
    account = Account.create!(:owner => org)
    saver = User.create!(
      :login => "samantha",
      :email => "samantha@example.com",
      :description => "Samantha is saving to open her own framing business.",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
#    photo = Photo.new(
#            :name => "Washington CASH Saver",
#            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/WACASH_saver1.jpg", 'image/jpg'),
#            :user => saver)
#    photo.save
#    saver.avatar = photo
#    saver.save
    saverCase = AssetDevelopmentCase.create!(
            :user => saver,
            :asset_type => business,
            :requested_match_total => "2000",
            :organization => org)
    account = Account.create!(:owner => saverCase)

    org = Organization.create!(:name => 'EARN')
    account = Account.create!(:owner => org)
    saver = User.create!(
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
#    photo = Photo.new(
#            :name => "EARN Saver",
#            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/EARN_saver1.jpg", 'image/jpg'),
#            :user => saver)
#    photo.save
#    saver.avatar = photo
#    saver.save
    saverCase = AssetDevelopmentCase.create!(
            :user => saver,
            :asset_type => education,
            :requested_match_total => "2000",
            :organization => org)
    account = Account.create!(:owner => saverCase)


    org = Organization.create!(:name => 'Opportunity Fund')
    account = Account.create!(:owner => org)
    saver = User.create!(
      :login => "rosie",
      :email => "rosie@example.com",
      :description => "Rosie is saving to open her own produce stand at the local public market.",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanjose,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
#    photo = Photo.new(
#            :name => "Opportunity Fund Saver",
#            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/Opportunity_saver1.jpg", 'image/jpg'))
#    photo.user = saver
#    photo.save
#    saver.avatar = photo
#    saver.save
    saverCase = AssetDevelopmentCase.create!(
            :user => saver,
            :asset_type => business,
            :requested_match_total => "2000",
            :organization => org)
    account = Account.create!(:owner => saverCase)

    org = Organization.create!(:name => 'Lawrence Community Works')
    account = Account.create!(:owner => org)
    saver = User.create!(
      :login => "sonja",
      :email => "sonja@example.com",
      :description => "Sonja is saving to open her own produce stand at the local public market.",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ma,
      :metro_area => lawrence,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:member],
      :saver => true)
    saver.activate
#    photo = Photo.new(
#            :name => "Lawrence Community Works Saver",
#            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/LCW_saver_1.JPG", 'image/jpg'),
#            :user => saver)
#    photo.save
#    saver.avatar = photo
#    saver.save
    saverCase = AssetDevelopmentCase.create!(
            :user => saver,
            :asset_type => business,
            :requested_match_total => "2000",
            :organization => org)
    account = Account.create!(:owner => saverCase)
  end
end
