class MakeNonPublicOrgsPrivate < ActiveRecord::Migration
  def self.up
    stOrg = Organization.find_savetogether_org
    stOrg.profile_public = false;
    stOrg.save
    paypal = Organization.find_paypal_org
    paypal.profile_public = false;
    paypal.save
  end

  def self.down
    stOrg = Organization.find_savetogether_org
    stOrg.profile_public = true;
    stOrg.save
    paypal = Organization.find_paypal_org
    paypal.profile_public = true;
    paypal.save
  end
end
