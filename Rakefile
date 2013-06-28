task :upload do
  require './lib/upload.rb'
  
  # Build bootstrap
  `make`
  
  # Upload files
  
  puts "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#"
  puts "Uploading files..."
  puts "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\n\n"
  
  Dir.glob('./docs/assets/*').each do |folder|
    BootstrapUpload.read_dir(folder)
  end
end

task :default => [:upload]