module HatenaBookmarkCLI
  # config
  HOME_DIR    = File.expand_path "~/.hatena-bookmark-cli"
  CONFIG_FILE = File.expand_path 'config.yml', HOME_DIR
  STORE_FILE  = File.expand_path 'store.yml', HOME_DIR

  FileUtils.mkdir_p HOME_DIR
  FileUtils.touch CONFIG_FILE
  FileUtils.chmod 0600, CONFIG_FILE
  FileUtils.touch STORE_FILE
  FileUtils.chmod 0600, STORE_FILE
end
