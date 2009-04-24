class CreateConfigurationData < ActiveRecord::Migration
  def self.up
    Country.destroy_all
    State.destroy_all
    MetroArea.destroy_all
    AssetType.destroy_all

    us = Country.create(:name => "United States")

    wa = State.create(:name => "WA")
    ca = State.create(:name => "CA")
    ma = State.create(:name => "MA")

    sanfran = MetroArea.create(:name => 'San Francisco', :state => ca, :country => us)
    seattle = MetroArea.create(:name => 'Seattle', :state => wa, :country => us)
    lawrence = MetroArea.create(:name => 'Lawrence', :state => ma, :country => us)
    sanjose = MetroArea.create(:name => 'San Jose', :state => ca, :country => us)

    education = AssetType.create :asset_name => "education"
    home = AssetType.create :asset_name => "home"
    business = AssetType.create :asset_name => "business"

    stOrg = Organization.create(:name => 'SaveTogether')
    account = Account.create(:owner => stOrg)      
  end

  def self.down
    MetroArea.destroy_all
    State.destroy_all
    Country.destroy_all
    AssetType.destroy_all
  end
end
