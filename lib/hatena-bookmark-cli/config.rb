module HatenaBookmarkCLI
  require 'yaml'
  require 'fileutils'

  require_relative 'version'
  require_relative 'constants'

  module Config
    def self.load
      YAML.load_file(CONFIG_FILE) || {}
    end

    def self.save obj
      File.open CONFIG_FILE, "w" do |f|
        f.write obj.to_yaml
      end
    end
  end
end
