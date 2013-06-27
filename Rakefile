task :upload do
  require './lib/upload.rb'
  
  # Build bootstrap
  system("make")
  
  # Upload files
  Dir.glob('./docs/assets/*').each do |folder|
    BootstrapUpload.read_dir(folder)
  end
end

task :default => [:upload]