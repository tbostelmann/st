require File.dirname(__FILE__) + '/../test_helper'

class PartyTest < ActiveSupport::TestCase
  
  # These tests protect the current contract of the overloaded Party#<=> operator

  test "short_description? should return false if there is no text" do
    saver = Saver.new

    assert saver.short_description.nil?
    assert !saver.short_description?

    saver.short_description = ""
    assert saver.short_description == ""
    assert !saver.short_description?

    saver.short_description = "test"
    assert saver.short_description == "test"
    assert saver.short_description?
  end

  test "find_public only returns profile_public == true" do
    orgs = Organization.find_public(:all)
    assert !orgs.nil?
    orgs.each do |org|
      assert org.profile_public
    end
  end
  
  test "parties are sortable by first name" do
    parties = []
    parties << Donor.new({:first_name => "Maude", :last_name => "Adams"})
    parties << Donor.new({:first_name => "Harold", :last_name => "Pinter"})
    parties.sort!
    
    assert_equal "Harold", parties[0].first_name
    assert_equal "Maude",  parties[1].first_name
    assert_equal "Pinter", parties[0].last_name
    assert_equal "Adams",  parties[1].last_name
  end
  
  test "organizations always sort below donors" do
    parties = []
    parties << Donor.new({:first_name => "William"})
    parties << Donor.new({:first_name => "Harold"})
    parties << Organization.new({:first_name => "Berts Bees"})
    parties << Organization.new({:first_name => "AAA Rental"})
    parties.sort!
    
    assert_equal "Harold",     parties[0].first_name
    assert_equal "William",    parties[1].first_name
    assert_equal "AAA Rental", parties[2].first_name
    assert_equal "Berts Bees", parties[3].first_name
  end
  
  test "organizations always sort below savers" do
    parties = []
    parties << Saver.new({:first_name => "William"})
    parties << Saver.new({:first_name => "Harold"})
    parties << Organization.new({:first_name => "Berts Bees"})
    parties << Organization.new({:first_name => "AAA Rental"})
    parties.sort!
    
    assert_equal "Harold",     parties[0].first_name
    assert_equal "William",    parties[1].first_name
    assert_equal "AAA Rental", parties[2].first_name
    assert_equal "Berts Bees", parties[3].first_name
  end
  
  test "donors and savers only sort by first name but otherwise do not sort into groups" do
    parties = []
    parties << Donor.new({:first_name => "William"})
    parties << Saver.new({:first_name => "Harold"})
    parties << Donor.new({:first_name => "Berts Bees"})
    parties << Saver.new({:first_name => "AAA Rental"})
    parties.sort!
    
    assert_equal "AAA Rental", parties[0].first_name
    assert_equal "Berts Bees", parties[1].first_name
    assert_equal "Harold",     parties[2].first_name
    assert_equal "William",    parties[3].first_name
  end
  
end