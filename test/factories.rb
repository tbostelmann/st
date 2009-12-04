require 'populator'
require 'faker'

##
# Users
##
Factory.sequence :email do |a|
  Faker::Internet.email
end

Factory.define :user do |s|
  s.first_name Faker::Name.first_name
  s.last_name Faker::Name.last_name
  s.login { Factory.next(:email) }
  s.login_slug {|saver| saver.login}
  s.description Populator.sentences(2..10)
  s.short_description Populator.sentences(1..2)
  s.salt "7e3041ebc2fc05a40c60028e2c4901a81035d3cd"
  s.crypted_password "00742970dc9e6319f8019fd54864d3ea740f04b1"
  s.birthday Populator.value_in_range(80.years.ago..21.years.ago)
  s.created_at Populator.value_in_range(30.days.ago..Time.now)
  s.updated_at {|saver| Populator.value_in_range(saver.created_at..Time.now)}
  s.activities_count 0
  s.role {|role| Role.find_by_name('member') }
  s.activated_at {|saver| Populator.value_in_range(saver.created_at..saver.updated_at)}
  s.profile_public true
  s.metro_area {|ma| MetroArea.find(:first, :order => 'rand()')}
  s.state {|a| a.metro_area.state}
end

Factory.define :saver, :parent => :user, :class => Saver do |s|
  s.organization {|a| Organization.find_partners(:first, :order => 'rand()')}
  s.requested_match_cents [100000, 150000, 200000].rand
  s.asset_type {|a| AssetType.find(:first, :order => 'rand()')}
end

Factory.define :donor, :parent => :user, :class => Donor do |d|
end

##
# LineItems
##
Factory.define :donation, :class => Donation do |d|
  d.cents [1000, 5000, 10000, 25000, 50000].rand
  d.association :to_user, :factory => :saver
end

Factory.define :donation_to_savetogether, :class => Donation do |d|
  d.cents [100, 500, 1000, 2500, 5000].rand
  d.to_user {|st| Organization.find_savetogether_org}
end

Factory.define :fee, :class => Fee do |f|
  f.cents [5, 10, 200, 500, 750].rand
  f.status [LineItem::STATUS_DENIED, LineItem::STATUS_EXPIRED, LineItem::STATUS_FAILED,
             LineItem::STATUS_PENDING, LineItem::STATUS_REFUNDED, LineItem::STATUS_REVERSED,
             LineItem::STATUS_PROCESSED, LineItem::STATUS_VOIDED, LineItem::STATUS_COMPLETED,
             LineItem::STATUS_CANCELED_REVERSAL].rand  
  f.from_user {|st| Organization.find_savetogether_org}
  f.to_user {|pp| Organization.find_paypal_org}
end


##
# Invoices
##
Factory.define :pledge do |p|
end

Factory.define :anonymous_unpaid_pledge, :class => Pledge do |p|
  p.donations {|a| [a.association(:donation, :status => nil, :invoice_id => a.id),
                    a.association(:donation_to_savetogether, :status => nil, :invoice_id => a.id)]}
end

Factory.define :pending_pledge, :class => Pledge do |p|
  p.association :donor, :factory => :donor
  p.donations {|a| [a.association(:donation, :from_user => a.donor, :status => LineItem::STATUS_PENDING, :invoice_id => a.id)]}
end

Factory.define :completed_pledge, :class => Pledge do |p|
  p.association :donor, :factory => :donor
  p.fees {|a| [a.association(:fee, :status => LineItem::STATUS_COMPLETED, :invoice_id => a.id)]}
  p.donations {|a| [a.association(:donation, :from_user => a.donor, :status => LineItem::STATUS_COMPLETED, :invoice_id => a.id)]}
end