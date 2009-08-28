require File.dirname(__FILE__) + '/../test_helper'

class CrumbTest < ActiveSupport::TestCase

  test "Crumb initialized with static paths always initialize path key to same value" do
    path = "/"
    crumb = Crumb.new(path)
    
    assert_equal path, crumb.path
    assert_equal path, crumb.path_key
  end
  
  test "Crumb initialized with different Savers paths initialize path key to a shared value" do
    path1 = "/savers/123"
    path2 = "/savers/236"
    crumb1 = Crumb.new(path1)
    crumb2 = Crumb.new(path2)
    
    assert_equal path1, crumb1.path
    assert_equal path2, crumb2.path
    
    assert_not_equal path1, crumb1.path_key
    assert_not_equal path2, crumb2.path_key
    
    assert_equal crumb1.path_key, crumb2.path_key
  end
  
  test "Two crumbs can be compared for equality" do
    commie1_crumb = Crumb.new("/community/")
    commie2_crumb = Crumb.new("/community/")
    match_crumb   = Crumb.new("/match-savers/")
    path1_crumb   = Crumb.new("/savers/123")
    path2_crumb   = Crumb.new("/savers/236")
    
    assert commie1_crumb.eql?(commie2_crumb), "Two crumbs with same paths and path_keys unexpectedly not equal"
    
    assert !commie1_crumb.eql?(match_crumb), "Two crumbs with different paths and path_keys unexpectedly equal"
    assert !commie2_crumb.eql?(match_crumb), "Two crumbs with different paths and path_keys unexpectedly equal"
    
    assert !path1_crumb.eql?(path2_crumb), "Two path-based crumbs with different paths unexpectedly equal"
  end

end
