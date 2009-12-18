# == Schema Information
# Schema version: 20091117074908
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  description               :text
#  avatar_id                 :integer(4)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  stylesheet                :text
#  view_count                :integer(4)      default(0)
#  vendor                    :boolean(1)
#  activation_code           :string(40)
#  activated_at              :datetime
#  state_id                  :integer(4)
#  metro_area_id             :integer(4)
#  login_slug                :string(255)
#  notify_comments           :boolean(1)      default(TRUE)
#  notify_friend_requests    :boolean(1)      default(TRUE)
#  notify_community_news     :boolean(1)      default(TRUE)
#  country_id                :integer(4)
#  featured_writer           :boolean(1)
#  last_login_at             :datetime
#  zip                       :string(255)
#  birthday                  :date
#  gender                    :string(255)
#  profile_public            :boolean(1)      default(TRUE)
#  activities_count          :integer(4)      default(0)
#  sb_posts_count            :integer(4)      default(0)
#  sb_last_seen_at           :datetime
#  role_id                   :integer(4)
#  type                      :string(255)
#  requested_match_cents     :integer(4)
#  asset_type_id             :integer(4)
#  organization_id           :integer(4)
#  first_name                :string(255)
#  last_name                 :string(255)
#  web_site_url              :string(255)
#  phone_number              :string(255)
#  notify_advocacy           :boolean(1)
#  short_description         :string(255)
#  featured_user             :boolean(1)      default(TRUE)
#

class Organization < Party
  has_one :organization_survey
  has_many :savers
  has_many :all_donations_received, :class_name => 'Donation', :foreign_key => :to_user_id
  has_many :donations_received, :class_name => 'Donation', :foreign_key => :to_user_id,
           :conditions => "status = '#{LineItem::STATUS_PROCESSED}' OR status = '#{LineItem::STATUS_PENDING}'"
           
  has_many :fees_paid, :class_name => 'Fee', :foreign_key => :from_user_id
  has_many :fees_received, :class_name => 'Fee', :foreign_key => :to_user_id

  accepts_nested_attributes_for :organization_survey

  PAYPAL_LOGIN = 'paypal@savetogether.org'
  SAVETOGETHER_LOGIN = 'storg@savetogether.org'
  CFED_LOGIN = 'cfed@savetogether.org'
  
  def self.find_savetogether_org
    find_by_login(SAVETOGETHER_LOGIN)
  end

  def self.find_paypal_org
    find_by_login(PAYPAL_LOGIN)
  end

  def self.find_partners(*args)
    with_scope(:find => {:conditions => ["login != ? AND login != ? AND login != ?", SAVETOGETHER_LOGIN, PAYPAL_LOGIN, CFED_LOGIN]}) do
      find(*args)
    end
  end

  def self.find_random(count=4)
    find_public(:all, :limit => count, :order => 'random()')
  end

  def find_random_savers(count=3)
    self.savers.find_public(:all, :limit => count, :order => 'random()')
  end

  def find_random_saver
    savers = find_random_savers(1)
    if !savers.nil? && savers.size == 1
      return savers[0]
    else
      return
    end
  end

  def has_organization_survey?
    return !self.organization_survey.nil?
  end

  def to_param
    self.id.to_s
  end

  def display_name
    first_name
  end  
end
