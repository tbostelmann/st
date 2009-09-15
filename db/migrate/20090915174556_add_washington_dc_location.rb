class AddWashingtonDcLocation < ActiveRecord::Migration
  def self.up
    us = Country.create!(:name => "United States")
    dc = State.create!(:name => "DC")
    MetroArea.create!(:name => 'Washington', :state => dc, :country => us)
  end

  def self.down
    wa = MetroArea.find_by_name('Washington')
    wa.destroy
    dc = State.find_by_name('DC')
    dc.destroy
  end
end
