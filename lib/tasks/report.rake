namespace :report do
  desc "Generate reports"
  task :line_items => :environment do
    puts LineItem.report_table(:all, :methods =>
            [:to_user_organization_display_name,
             :to_user_display_name,
             :from_user_display_name]).to_csv
  end
end
