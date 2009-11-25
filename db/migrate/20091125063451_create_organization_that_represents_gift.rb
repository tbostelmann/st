class CreateOrganizationThatRepresentsGift < ActiveRecord::Migration
  def self.up
    require 'action_controller'
    require 'action_controller/test_process.rb'

    Organization.transaction do
      giftCard = Organization.create(
        :first_name => 'GiftCard',
        :login => "storg+giftcard4@savetogether.org",
        :login_confirmation => "storg+giftcard4@savetogether.org",
        :description => "<p>Organization that represents a gift</p>",
        :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
        :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
        :birthday => 30.years.ago,
        :activities_count => 0,
        :profile_public => false,
        :role => Role[:member])
      giftCard.activate
      photo = Photo.new(
              :name => "GiftCard Logo",
              :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/GiftCard.jpg", "image/jpg"),
              :user => giftCard)
      photo.save
      giftCard.avatar = photo
      giftCard.save
    end
  end

  def self.down
    giftCard = Organization.find_by_login("storg+giftcard3@savetogether.org")
    if giftCard.nil?
      raise "GiftCard does not exist!"
    end
    giftCard.delete
  end
end
