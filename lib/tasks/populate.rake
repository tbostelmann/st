namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller'
    require 'action_controller/test_process.rb'

    stOrg = Organization.find_savetogether_org

    paypal = Organization.find_paypal_org
    all_savers = []
    Saver.find(:all).each do |saver|
      all_savers << saver.id
    end
    Donor.populate 200 do |donor|
      donor.login = Faker::Internet.email
      donor.email = donor.login
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
      donor.notify_advocacy = 0..1
      if donor.notify_advocacy
        donor.zip = Faker::Address.zip_code
      end 
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
    Donor.find(:all).each do |d|
      d.generate_login_slug
      d.save!
    end
  end
end
