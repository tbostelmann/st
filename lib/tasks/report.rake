namespace :report do
  desc "Generate reports"
  task :line_items => :environment do
    puts LineItem.report_table(:all, :methods =>
            [:to_user_organization_display_name,
             :to_user_display_name,
             :from_user_display_name]).to_csv
  end

  task :donors_without_donations => :environment do
    donors = Donor.find(:all)
    donors.each do |donor|
      unless !donor.beneficiaries.nil? && donor.beneficiaries.size > 0
        puts "\"#{donor.first_name} #{donor.last_name}\" <#{donor.email}>\n"
      end
    end
  end

  task :donor_emails => :environment do
    donors = Donor.all
    donors.each do |donor|
      puts "\"#{donor.first_name} #{donor.last_name}\" <#{donor.email}>\n"
    end
  end
end
