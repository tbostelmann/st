require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  include ActionController::TestProcess

  fixtures :all

  test "create minimum photo" do
    user = users(:saver)
    assert !user.nil?
    photo = Photo.new(
      :uploaded_data => ActionController::TestUploadedFile.new(
        "#{RAILS_ROOT}/test/files/WACASH_saver1.jpg",
        'image/jpg',
        false
      )
    )
    photo.user = user
    isvalid = photo.valid?
    assert isvalid
  end
end
