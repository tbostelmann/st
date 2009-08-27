require File.dirname(__FILE__) + '/../test_helper'

include HanselHelper

class HanselHelperTest < ActiveSupport::TestCase

  def setup
    # Do this because loading this yaml directly under a fixtures directory expects a database table connection
    @mock_url_friendly_names = YAML.load_file(File.join(Rails.root, "test", "fixtures", "no_model", "mock_url_friendly_names.yml"))

    # also mock a request object
    @mock_request = OpenStruct.new #{:path => "/"} paths will be added by tests
  end
  
  test "Hansel supports path-to-friendly-name mapping" do
    assert_equal @mock_url_friendly_names.size, URL_FRIENDLY_NAMES.size
    @mock_url_friendly_names.each do |fn|
      assert_not_nil URL_FRIENDLY_NAMES.include?(fn), "URL_FRIENDLY_NAMES did not include #{fn}"
    end
  end
  
  test "Crumb trail grows with new paths" do
    assert_crumbs(%w(/, /do-more, /match/)) do |path|
      drop_this_crumb(path)
    end
  end
  
  test "Crumb trail pruned when user circles back to earlier traversed path" do
    initial_paths = %w(/, /do-more, /match/)
    all_paths     = initial_paths + %w(/pledge/add_to_pledge, /pledge/savetogether_ask)
    
    # User traverses long path
    assert_crumbs(all_paths) do |path|
      drop_this_crumb(path)
    end
    
    # User circles back
    drop_this_crumb(initial_paths.last)
    
    # Crumb trail should be trimmed
    assert_crumbs(initial_paths)
  end
  
  test "User returning to last visited path results in no change to the crumb trail" do
    some_paths = %w(/, /do-more, /match/)
    
    # User traverses long path
    assert_crumbs(some_paths) do |path|
      drop_this_crumb(path)
    end
    
    # User circles back
    drop_this_crumb(some_paths.last)
    
    # Crumb trail should be still match original path
    assert_crumbs(some_paths)    
  end
  
  test "RESTful paths with indexes are saved and matched as generic patterns" do
    initial_path = %w(/ /match /saver/201)
    all_paths    = initial_path + %w(/donor/302)
    
    # Traverse long path through specific profiles
    assert_crumbs(all_paths) do |path|
      drop_this_crumb(path)
    end
    
    # User circles back to different saver
    drop_this_crumb("/saver/206")
    
    # Crumb trail should match original path because last and first saver
    # match generically, so crumbs are popped back to the first one
    assert_crumbs(initial_path)    
  end
  
protected

  def drop_this_crumb(path)
    @mock_request.path = path
    drop_crumb(@mock_request) # the HanselHelper method
  end
  
  # This method takes an optional block this is expected to drop a
  # bread crumb for the specified path. Afterwards (and otherwise) the
  # bread crumb trail is asserted to contain the expected path members.
  #
  # If no block, then just assert the paths as the expected data against
  # the current bread crumb trail.
  def assert_crumbs(paths)
    paths.each_index do |i|
      if block_given?
        yield paths[i]
        assert_equal i+1, user_crumb_trail.size
      else
        assert_equal paths.size, user_crumb_trail.size
      end
      (0..i).each{|i| assert_match Regexp.new(user_crumb_trail[i]), paths[i]}
    end
  end
  
  def paths_to_s(paths)
    "Paths: \"#{paths.join("\", \"")}\""
  end
  
end