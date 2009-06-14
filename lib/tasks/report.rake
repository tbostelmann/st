namespace :report do
  desc "Generate reports"
  task :all => :environment do
    puts LineItem.report_table(:all).to_csv
  end
end
