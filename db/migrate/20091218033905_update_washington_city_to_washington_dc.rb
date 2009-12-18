class UpdateWashingtonCityToWashingtonDc < ActiveRecord::Migration
  def self.up
    wa = MetroArea.find_by_name('Washington')
    wa.name = 'Washington D.C.'
    wa.save
  end

  def self.down
  end
end
