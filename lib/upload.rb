class BootstrapUpload
  require 'dotenv'
  require 'fog'
  Dotenv.load
  
  def self.read_dir(dir)
    Dir.foreach(dir) do |item|
      next if item == '.' or item == '..'
      file = dir + "/" + item
      key = file.gsub('./docs/assets/', '')
      if File.directory?(file)
        read_dir(file)
      else
        upload_file(file, key)
      end
    end
  end

  def self.upload_file(file, key)
    puts "Uploading #{key}"
    rackspace.files.create :key => key, :body => File.open(file)
  end

  def self.rackspace
    @@dir ||= nil
    if @@dir.nil?
      service = Fog::Storage.new({
          :provider            => 'Rackspace',
          :rackspace_username  => ENV['RACKSPACE_USERNAME'],
          :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
          :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
          :rackspace_region    => :lon
      })  

      @@dir = service.directories.get ENV['RACKSPACE_CONTAINER']
    end
    @@dir
  end
  
end