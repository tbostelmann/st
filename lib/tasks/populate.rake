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

    stOrg = Organization.find_savetogether_org

    org = Organization.create!(
      :first_name => 'Washington CASH',
      :login => "wacash@savetogether.org",
      :login_confirmation => "wacash@savetogether.org",
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
      :login => "samantha@savetogether.org",
      :login_confirmation => "samantha@savetogether.org",
      :first_name => "Samantha",
      :last_name => "Saver",
      :description => "<p>Samantha is saving for a downpayment towards a house. Samantha's dream is to own her own home. She is saving to provide a home for her 2 children. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Samantha was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 28.years.ago,
      :gender => "F",
      :activities_count => 0,
      :role => Role[:member],
      :organization => org,
      :asset_type => Home,
      :requested_match_amount => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Washington CASH Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/WACASH_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :first_name => 'EARN',
      :login => "earn@savetogether.org",
      :login_confirmation => "earn@savetogether.org",
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
      :login => "juanita@savetogether.org",
      :login_confirmation => "juanita@savetogether.org",
      :first_name => "Juanita",
      :last_name => "Somesavings",
      :description => "<p>Juana's dream is to get a nursing degree and work in an emergency room. She is saving to enroll at the City College of San Francisco School of Nursing. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Juana was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanfran,
      :birthday => 25.years.ago,
      :gender => "F",
      :activities_count => 0,
      :role => Role[:member],
      :organization => org,
      :asset_type => Education,
      :requested_match_amount => "2000")
    saver.activate
    photo = Photo.new(
            :name => "EARN Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/EARN_saver1.jpg", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :first_name => 'Opportunity Fund',
      :login => "opportunityfund@savetogether.org",
      :login_confirmation => "opportunityfund@savetogether.org",
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
      :login => "rosie@savetogether.org",
      :login_confirmation => "rosie@savetogether.org",
      :first_name => "Rosie",
      :last_name => "Outlook",
      :description => "Rosie is saving to open her own produce stand at the local public market. Since completing high school, she has worked for two years as a retail clerk to help afford the tuition.</p>  <p>Last year, Samantha was selected to open a matched savings account with Opportunity Fund, one of the leading microfinance organizations in America. She is saving diligently every month, and attending classes on money management and college readiness.</p><p>I have always been told that I have a gift for making people feel better,' she says. 'I will make the most of the help I am getting from Opportunity Fund, and I intend to give back by caring for people who are facing emergencies'.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ca,
      :metro_area => sanjose,
      :birthday => 35.years.ago,
      :gender => "F",
      :activities_count => 0,
      :role => Role[:member],
      :organization => org,
      :asset_type => Business,
      :requested_match_amount => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Opportunity Fund Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/Opportunity_saver1.jpg", 'image/jpg'))
    photo.user = saver
    photo.save
    saver.avatar = photo
    saver.save

    org = Organization.create!(
      :first_name => 'Lawrence Community Works',
      :login => "lcw@savetogether.org",
      :login_confirmation => "lcw@savetogether.org",
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
      :login => "sonja@savetogether.org",
      :login_confirmation => "sonja@savetogether.org",
      :first_name => "Sonja",
      :last_name => "Blinksi",
      :description => "Sonja is saving to open her own crafts stand at the local flea market. Sonja is eager to provide a valuable service to the community. She will leverage her considerable strengths in putting together innovative craft projects. She has been helping elementary school children for the past 10 years in after school arts and crafts programs.",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => ma,
      :metro_area => lawrence,
      :birthday => 45.years.ago,
      :gender => "F",
      :activities_count => 0,
      :role => Role[:member],
      :organization => org,
      :asset_type => Business,
      :requested_match_amount => "2000")
    saver.activate
    photo = Photo.new(
            :name => "Lawrence Community Works Saver",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/LCW_saver_1.JPG", 'image/jpg'),
            :user => saver)
    photo.save
    saver.avatar = photo
    saver.save

    paypal = Organization.find_paypal_org
    all_savers = []
    Saver.find(:all).each do |saver|
      all_savers << saver.id
    end
    Donor.populate 200 do |donor|
      donor.login = Faker::Internet.email
      donor.first_name = Faker::Name.first_name
      donor.last_name = Faker::Name.last_name
      donor.description = Populator.sentences(2..10)
      donor.salt = "7e3041ebc2fc05a40c60028e2c4901a81035d3cd"
      donor.crypted_password = "00742970dc9e6319f8019fd54864d3ea740f04b1"
      donor.birthday = 80.years.ago..21.years.ago
      donor.created_at = 30.days.ago..Time.now
      donor.updated_at = donor.created_at..Time.now
      donor.activities_count = 0
      donor.role_id = Role[:member].id
      donor.activated_at = donor.created_at..donor.updated_at
      donor.profile_public = 0..1
      Pledge.populate 1 do |pledge|
        pledge.donor_id = donor.id
        pledge.created_at = donor.activated_at..Time.now
        d1 = nil
        Donation.populate 1 do |donation|
          donation.cents = [1000, 1500, 2000, 2500, 3000, 5000, 6000, 7500, 10000]
          donation.status = [
                  LineItem::STATUS_DENIED, LineItem::STATUS_FAILED,
                  LineItem::STATUS_PENDING, LineItem::STATUS_PROCESSED,
                  LineItem::STATUS_COMPLETED, LineItem::STATUS_VOIDED]
          donation.from_user_id = donor.id
          donation.to_user_id = all_savers
          donation.created_at = pledge.created_at
          donation.invoice_id = pledge.id
          d1 = donation
        end
        Donation.populate 0..1 do |donation2|
          donation2.cents = [100, 150, 200, 250, 300, 500, 600, 750, 1000]
          donation2.status = d1.status
          donation2.from_user_id = donor.id
          donation2.to_user_id = stOrg.id
          donation2.created_at = pledge.created_at
          donation2.invoice_id = pledge.id
        end
      end
    end
    Pledge.find(:all).each do |pledge|
      li1 = pledge.donations[0]
      if li1.status == LineItem::STATUS_COMPLETED || li1.status == LineItem::STATUS_PROCESSED
        Fee.populate 1 do |fee|
          fee.cents = li1.cents / 100
          fee.status = li1.status
          fee.from_user_id = stOrg.id
          fee.to_user_id = paypal.id
          fee.created_at = li1.created_at + 24.hours
          fee.invoice_id = pledge.id
        end
      pledge.donations.each do |d|
        d.updated_at = d.created_at + 24.hours
        d.save!
      end
      end
    end
  end
end
