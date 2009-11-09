require 'populator'
require 'faker'

Factory.define :user do |s|
  s.first_name Faker::Name.first_name
  s.last_name Faker::Name.last_name
  s.login Faker::Internet.email
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

Factory.define :line_item do |li|
  li.cents [100, 500, 1000, 2500, 5000].rand
  li.status [LineItem::STATUS_DENIED, LineItem::STATUS_EXPIRED, LineItem::STATUS_FAILED,
             LineItem::STATUS_PENDING, LineItem::STATUS_REFUNDED, LineItem::STATUS_REVERSED,
             LineItem::STATUS_PROCESSED, LineItem::STATUS_VOIDED, LineItem::STATUS_COMPLETED,
             LineItem::STATUS_CANCELED_REVERSAL].rand
end

Factory.define :donation, :parent => :line_item, :class => Donation do |d|
  d.association :from_user, :factory => :donor
  d.association :to_user, :factory => :saver
end

Factory.define :fee, :parent => :line_item, :class => Fee do |f|
  f.from_user {|st| Organization.find_savetogether_org}
  f.to_user {|pp| Organization.find_paypal_org}
end

Factory.define :gift, :parent => :line_item, :class => Gift do |g|
end

Factory.define :new_pledge, :class => Pledge do |p|
  p.association :donor, :factory => :donor
  p.donations {|donations| [donations.association(:donation, :from_user => donations.donor)]}
  p.fees {|fees| [fees.association(:fee, :status => fees.donations[0].status)]}
end