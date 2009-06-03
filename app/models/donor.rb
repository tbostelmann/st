# == Schema Information
# Schema version: 20090422073021
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
#  full_name                 :string(255)
#

class Donor < Party

  has_many :pledges
  has_many :all_donations_given, :class_name => 'Donation', :foreign_key => :from_user_id
  has_many :donations_given, :class_name => 'Donation', :foreign_key => :from_user_id,
           :conditions => "status = '#{LineItem::STATUS_PROCESSED}' OR status = '#{LineItem::STATUS_PENDING}'"
  has_many :beneficiaries, :through => :donations_given, :source => :to_user,
           :uniq => true, :conditions => "users.type = 'Saver'"
  
  # validates_confirmation_of :login
  # The following was written because we can't figure out why the above doesn't get called
  validate :confirmation_of_login

  # Make login and email the same
  def login=(login)
    becomes(User).email = login
    super
  end
  
  # Only allow email manipulation via login accessor
  def email=(email)
    raise "email lockdown: To set email attribute call login"
  end
  
  # Virtual accessors to support our hand-rolled login (as email) confirmation
  def login_confirmation
    @login_confirmation
  end
  
  def login_confirmation=(login)
    @login_confirmation = login
  end
  
  # Examine validation state and manipulate to make sure we can save parties that meet
  # new requirements of login equaling email - CE user login validations are still flushed,
  # but we do this copy trick to get rid of them. Because email format is now login
  # format, email validation errors are now "rebranded" as login validation errors.
  
  def validate
    repl_errs = User.new.errors
    # Copy all errors except login errors, and any email errors re-key as login errors
    errors.each do |e, m|
      case e
        when "email", "party_login" then repl_errs.add :login, m
        when "login" then #skip
        else repl_errs.add e, m
      end
    end
    errors.clear
    repl_errs.each {|e, m| errors.add(e, m)}
  end
  
  private
  
  # Hand-rolled login (as email) confirmation
  def confirmation_of_login
    errors.add :party_login, "doesn't match confirmation" unless login == login_confirmation
  end
end
