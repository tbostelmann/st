class CreateConfigurationData < ActiveRecord::Migration
  def self.up
    require 'action_controller'
    require 'action_controller/test_process.rb'

    Country.destroy_all
    State.destroy_all
    MetroArea.destroy_all
    AssetType.destroy_all

    us = Country.create!(:name => "United States")

    wa = State.create!(:name => "WA")
    ca = State.create!(:name => "CA")
    ma = State.create!(:name => "MA")

    sanfran = MetroArea.create!(:name => 'San Francisco', :state => ca, :country => us)
    spokane = MetroArea.create!(:name => 'Spokane', :state => wa, :country => us)
    boston = MetroArea.create!(:name => 'Boston', :state => ma, :country => us)

    education = AssetType.create! :asset_name => "Education"
    home = AssetType.create! :asset_name => "Home"
    business = AssetType.create! :asset_name => "Business"

    admin = Donor.create!(
      :login => "administrator@savetogether.org",
      :login_confirmation => "administrator@savetogether.org",
      :first_name => "Administrator",
      :last_name => "SaveTogether",
      :description => "Person with adminstrator role",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :birthday => 30.years.ago,
      :activities_count => 0,
      :role => Role[:admin])
    admin.activate    

    stOrg = Organization.create!(
      :first_name => 'SaveTogether',
      :login => "storg@savetogether.org",
      :login_confirmation => "storg@savetogether.org",
      :description => "<p>SaveTogether description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :birthday => 30.years.ago,
      :activities_count => 0,
      :profile_public => true,
      :role => Role[:member])
    stOrg.activate
    photo = Photo.new(
            :name => "SaveTogether Logo",
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/SaveTogetherLogoLeaf.jpg", "image/jpg"),
            :user => stOrg)
    photo.save
    stOrg.avatar = photo
    stOrg.save

    paypal = Organization.create!(
      :first_name => 'Paypal',
      :login => "paypal@savetogether.org",
      :login_confirmation => "paypal@savetogether.org",
      :description => "<p>Paypal description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :birthday => 30.years.ago,
      :activities_count => 0,
      :profile_public => true,
      :role => Role[:member])
    paypal.activate
  end

  def self.down
    MetroArea.destroy_all
    State.destroy_all
    Country.destroy_all
    AssetType.destroy_all
  end
end
