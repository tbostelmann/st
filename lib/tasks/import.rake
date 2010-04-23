namespace :import do
  # rake import:pledge
  desc "command: rake import:pledge '<from_id>' '<to_id> '<amount_cents>' - creates a pledge with one donation from a Donor to a Saver"
  task :pledge => :environment do
    fu = Donor.find_by_login(ENV['from'])
    tu = Saver.find_by_login(ENV['to'])
    am = ENV['amount']

    p = Pledge.create!(:donor => fu)
    d = Donation.create!(:from_user => fu, :to_user => tu, :cents => am,
                         :status => LineItem::STATUS_COMPLETED, :invoice => p)
  end

  # rake import:organizations ./test/files/import/OrgProfiles.csv
  desc "command: rake import:organizations <csv_file> - Import specified data into database"
  task :organizations => :environment do
    require 'action_controller'
    require 'action_controller/test_process.rb'
    require 'csv'

    csv_data = CSV.read $ARGV[1]
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    Organization.transaction do
      array_of_hashes.each do |org_data|
        org = Organization.create!(
          :first_name => org_data['first_name'],
          :login => org_data['login'],
          :login_confirmation => org_data['login'],
          :description => org_data['description'].gsub(/\n/, "<br>"),
          :web_site_url => org_data['web_site_url'],
          :phone_number => org_data['phone_number'],
          :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
          :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test 
          :state => State.find(:first, :conditions => {:name => org_data['state']}),
          :metro_area => MetroArea.find(:first, :conditions => {:name => org_data['metro_area']}),
          :birthday => 30.years.ago,
          :activities_count => 0,
          :role => Role[:member])
        org.activate
        if org_data['contact_email'] || org_data['year_founded'] || org_data['annual_operating_expenses'] ||
                    org_data['total_matched_accounts'] || org_data['year_first_accounts_opened'] ||
                    org_data['number_of_active_accounts']
          org_survey = OrganizationSurvey.create!(
            :organization => org,
            :contact_email => org_data['contact_email'],
            :year_founded => org_data['year_founded'],
            :annual_operating_expenses => org_data['annual_operating_expenses'],
            :total_matched_accounts => org_data['total_matched_accounts'],
            :year_first_accounts_opened => org_data['year_first_accounts_opened'],
            :number_of_active_accounts => org_data['number_of_active_accounts'])
        end
        photo = Photo.new(
                :name => "#{org_data['first_name']} Logo",
                :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/import/#{org_data['image_file']}", org_data['image_file_type']))
        photo.user = org
        photo.save
        org.avatar = photo
        org.save
      end
    end
  end

  # rake import:savers ./test/files/import/SaverProfiles.csv
  desc "command: rake import:savers <csv_file> - Import specified data into database"
  task :savers => :environment do
    require 'action_controller'
    require 'action_controller/test_process.rb'
    require 'csv'

    csv_data = CSV.read $ARGV[1]
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

    Saver.transaction do
      array_of_hashes.each do |saver_data|
        org = Organization.find(:first, :conditions => {:first_name => saver_data['org_name']})
        login = "#{saver_data['first_name'].delete(' ').downcase}#{saver_data['last_name'].delete(' ').downcase[0,1]}@savetogether.org"
        state = State.find(:first, :conditions => {:name => saver_data['state']})
        metro_area = MetroArea.find(:first, :conditions => {:name => saver_data['metro_area']})
        unless metro_area
          us = Country.create!(:name => "United States")
          metro_area = MetroArea.create!(:name => saver_data['metro_area'], :state => state, :country => us)
        end
        saver = Saver.create!(
          :login => saver_data['login'],
          :login_confirmation => saver_data['login'],
          :first_name => saver_data['first_name'],
          :last_name => saver_data['last_name'],
          :short_description => saver_data['short_description'],
          :description => saver_data['description'].gsub(/\n/, "<br>"),
          :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
          :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
          :state => state,
          :metro_area => metro_area,
          :birthday => 28.years.ago,
          :activities_count => 0,
          :role => Role[:member],
          :organization => org,
          :asset_type => AssetType.find(:first, :conditions => {:asset_name => saver_data['asset_type']}),
          :requested_match_amount => saver_data['requested_match_amount'])
        saver.activate
        photo = Photo.new(
                :name => saver_data['first_name'],
                :uploaded_data => ActionController::TestUploadedFile.new("#{RAILS_ROOT}/test/files/import/#{saver_data['image_file']}", 'image/jpg', false))
        photo.user = saver
        unless photo.save
          raise "Photo did not save!"
        end
        saver.avatar = photo
        unless saver.save
          raise "Saver did not save!"
        end
      end
    end
  end
end
