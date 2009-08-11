namespace :site do
  offline_base_dir="offline"
  public_base_dir="public"
  # relies on rules in nginx about what to do if a specific file is present
  desc "Show site's current status..."
  task :status => :environment do
    puts "Getting site @ #{RAILS_ENV} status ..."
    magic_file = "public/system/maintenance.html"
    site_status =  File.file?(magic_file) ? 'offline' : 'online'
    puts "Site is #{site_status}"
  end
  desc "put site 'online' via nginx mechanism ..."
  task :online => :environment do
    puts "Changing site @ #{RAILS_ENV} to be ONLINE"
    src_files=FileList[File.join(offline_base_dir,"**/*")]
    puts "src_files = #{src_files.inspect}"
    # remove files that part of the "offline state"
    src_files.each do |src_file|
      dest_file = src_file.pathmap("%{#{offline_base_dir},#{public_base_dir}}p")
      # puts "#{dest_file}"
      FileUtils.rm_f(dest_file , :verbose => true , :noop => false) if File.file?(src_file)
    end
    puts "... ONLINE."
  end
  desc "put site 'offline' via nginx mechanism ..."
  task :offline => :environment do
    puts "Changing site @ #{RAILS_ENV} to be OFFLINE..."
    src_files=FileList[File.join(offline_base_dir,"**/*")]
    puts "src_files = #{src_files.inspect}"
    FileUtils.cp_r( File.join(offline_base_dir,'/.' ), public_base_dir , :verbose => true)
    # or do it by hand ...
    # src_files.each do |src_file|
      # dest_file = src_file.pathmap("%{#{offline_base_dir},#{public_base_dir}}p")
      # puts "#{dest_file}"
      # dir_name = File.dirname(dest_file)
      # FileUtils.mkdir_p dir_name
      # if File.file?(src_file)
        # FileUtils.cp(src_file, dest_file , :verbose => false )
      # end
    # end
    puts "... OFFLINE."
  end
end

