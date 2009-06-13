class CreateConfigurationData < ActiveRecord::Migration
  def self.up
    Country.destroy_all
    State.destroy_all
    MetroArea.destroy_all
    AssetType.destroy_all

    us = Country.create!(:name => "United States")

    wa = State.create!(:name => "WA")
    ca = State.create!(:name => "CA")
    ma = State.create!(:name => "MA")

    sanfran = MetroArea.create!(:name => 'San Francisco', :state => ca, :country => us)
    seattle = MetroArea.create!(:name => 'Seattle', :state => wa, :country => us)
    lawrence = MetroArea.create!(:name => 'Lawrence', :state => ma, :country => us)
    sanjose = MetroArea.create!(:name => 'San Jose', :state => ca, :country => us)

    sanfran = MetroArea.find(:first, :conditions => {:name => 'San Francisco'})
    seattle = MetroArea.find(:first, :conditions => {:name => 'Seattle'})
    lawrence = MetroArea.find(:first, :conditions => {:name => 'Lawrence'})
    sanjose = MetroArea.find(:first, :conditions => {:name => 'San Jose'})

    education = AssetType.create! :asset_name => "Education"
    home = AssetType.create! :asset_name => "Home"
    business = AssetType.create! :asset_name => "Business"

    admin = Donor.create!(
      :login => "admin@savetogether.org",
      :login_confirmation => "admin@savetogether.org",
      :first_name => "Tom",
      :last_name => "B",
      :description => "Person with adminstrator role",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :gender => "M",
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
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :profile_public => false,
      :role => Role[:member])
    stOrg.activate

    paypal = Organization.create!(
      :first_name => 'Paypal',
      :login => "paypal@savetogether.org",
      :login_confirmation => "paypal@savetogether.org",
      :description => "<p>Paypal description.</p>",
      :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
      :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
      :state => wa,
      :metro_area => seattle,
      :birthday => 30.years.ago,
      :activities_count => 0,
      :profile_public => false,
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
