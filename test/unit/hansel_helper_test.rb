require File.dirname(__FILE__) + '/../test_helper'

include HanselHelper

class HanselHelperTest < ActiveSupport::TestCase

  # Pull, and if nothing left, pull test
  
  # def setup
  #   # Do this because loading this yaml directly under a fixtures directory expects a database table connection
  #   @mock_url_friendly_names = YAML.load_file(File.join(Rails.root, "test", "fixtures", "no_model", "mock_url_friendly_names.yml"))
  # 
  #   # also mock a request object
  #   @mock_request = OpenStruct.new #{:path => "/"} paths will be added by tests
  # end
  # 
  # test "Hansel supports path-to-friendly-name mapping" do
  #   assert_equal @mock_url_friendly_names.size, URL_FRIENDLY_NAMES.size
  #   @mock_url_friendly_names.each do |fn|
  #     assert_not_nil URL_FRIENDLY_NAMES.include?(fn), "URL_FRIENDLY_NAMES did not include #{fn}"
  #   end
  # end
  
end