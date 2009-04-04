namespace :assetdata do
  desc "Add asset goal amt and amt left data for 4 savers"
  task :add_asset_data => :environment do
    #add some fake total amount and amount left data here
    peopledata = { 1=>{:requested_match_total => '2000.00', :requested_match_left=>'500.00'}, 2=>{:requested_match_total=>'1500.00', :requested_match_left=>'10.00'}, 3=>{:requested_match_total=>'1000.00', :requested_match_left=>'325.22'}, 4=>{:requested_match_total=>'567.11', :requested_match_left=>'1.23'}}
   AssetDevelopmentCase.update(peopledata.keys,peopledata.values)
  end
end
