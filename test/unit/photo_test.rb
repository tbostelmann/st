require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test "create minimum photo" do
    photo = Photo.create(
            :uploaded_data => fixture_file_upload("../files/WACASH_saver1.jpg", 'image/jpg')
    )
    assert photo.valid?
  end
end
