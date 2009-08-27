# == Schema Information
# Schema version: 20090701201617
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
#

class Donor < Party
  has_one :donor_survey
  has_many :pledges
  has_many :all_donations_given, :class_name => 'Donation', :foreign_key => :from_user_id
  has_many :donations_given, :class_name => 'Donation', :foreign_key => :from_user_id,
           :conditions => "status = '#{LineItem::STATUS_PROCESSED}' OR status = '#{LineItem::STATUS_COMPLETED}'"
  has_many :beneficiaries, :through => :donations_given,
           :source => :to_user,
           :conditions => "users.type = 'Saver'",
           :uniq => true
  
  validates_presence_of :first_name
  validates_presence_of :last_name

  def donations_grouped_by_beneficiaries
    donations_given.find(:all).group_by{ |d| d.to_user }
  end
  
  def most_recent_donation
    donations_given.find(
        :first,
        :order => "created_at desc",
        :joins => "join users on to_user_id = users.id",
        :conditions => "users.type = 'Saver'")
  end
    
  def activate
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save
  end
end
