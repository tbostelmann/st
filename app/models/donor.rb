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
  belongs_to :referred_by_donor,
                    :class_name => "Donor",
                    :foreign_key => "referred_by_donor_id"
  has_many :referrees,
                  :class_name => "Donor",
                  :foreign_key => "referred_by_donor_id"
  
  validates_presence_of :first_name
  validates_presence_of :last_name

  def self.find_featured_donor(number=1)
    find_random(:all, :limit => number, :conditions => ["description is NOT NULL AND description <> '' AND avatar_id is NOT NULL"])
  end

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
  
  def total_donation_amount
    return self.donations_given.inject( Money.new( 0 ) ) { | sum, donation | sum += donation.amount }
  end
  
  def pyramid_of_referrees( ancestors = Array.new, original_donor = nil )
    if original_donor.nil? then original_donor = self end
    ancestors << self
    direct_refs = ( self.referrees.select { | each_referree | !ancestors.include?( each_referree ) } )
    all_referred_donors = direct_refs
    direct_refs.each do | each_ref |
      all_referred_donors += each_ref.pyramid_of_referrees(ancestors, original_donor )
    end
    return all_referred_donors
  end
  
  def number_of_pyramid_referrees
    return self.pyramid_of_referrees.size
  end
  
  def pyramid_total( ancestors = Array.new )
    if ancestors.empty? then
      starting_amount = Money.new( 0 )
    else
      starting_amount = self.total_donation_amount
    end
    ancestors << self
    refs = ( self.referrees.select { | each_referree | !ancestors.include?( each_referree ) } )
    return refs.inject( starting_amount ) { | sum, e | sum += e.pyramid_total( ancestors ) }
  end
  
  def set_up_referrer_from_email( referral_email )
    if !( self.referrer_email == referral_email )
      referrer = Donor.find_donor_with_email_address( referral_email )
      if referrer then self.referred_by_donor = referrer end
    end
  end
  
  def self.find_donor_with_email_address( email )
    Donor.find_by_email( email )
  end
  
  def referrer_email
    donor = self.referred_by_donor
    if donor
      return donor.email
    else
      return ''
    end
  end
  
  def referrer_name
    donor = self.referred_by_donor
    if donor
      return donor.display_name
    else
      return ''
    end
  end
	
  def has_significant_pyramid_base?  
    active_sub_donor_count = 0
    boolean = true
    none_found = lambda { boolean = false }
    self.referrees.detect( none_found) do | each_donor | 
      if ( each_donor.pyramid_total( [ self ] ) > ( Money.new( 0 ) ) ||
          each_donor.total_donation_amount > ( Money.new( 0 ) ) ) then
        active_sub_donor_count += 1
      end
      active_sub_donor_count >= 2
    end
    return boolean
  end

  def public_pyramid?
    return ( self.show_pyramid? and self.has_significant_pyramid_base? )
  end
  
end
