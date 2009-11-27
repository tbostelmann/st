class CreateOrganizationThatRepresentsGift < ActiveRecord::Migration
  def self.up
    require 'action_controller'
    require 'action_controller/test_process.rb'

    stOrg = Organization.create!(
      :first_name => 'SaveTogether',
      :login => "storg+giftcard@savetogether.org",
      :login_confirmation => "storg+giftcard@savetogether.org",
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
            :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/SaveTogetherLogoLeaf.jpg", "image/jpg"))
    photo.user = stOrg
    photo.save!
    stOrg.avatar = photo
    stOrg.save!
  end

  def self.down
    giftCard = Organization.find_by_login("storg+giftcard@savetogether.org")
    unless giftCard.nil?
      giftCard.delete
    end
  end
end
