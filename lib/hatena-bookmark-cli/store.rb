module HatenaBookmarkCLI
  require 'yaml'
  require 'fileutils'

  require_relative 'version'
  require_relative 'constants'

  module Store
    def self.load
      YAML.load_file(STORE_FILE) || {}
    end

    def self.save obj
      File.open STORE_FILE, "w" do |f|
        f.write obj.to_yaml
      end
    end
  end
end
