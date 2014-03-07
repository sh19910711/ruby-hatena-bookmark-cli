#!/usr/bin/env ruby

# Usage: command ${port}

PORT = ARGV[0] || "48080"

# サーバーを起動する
puts "rackup --port #{PORT} --env production"
system "cd #{File.expand_path "../..", __FILE__} && rackup --port #{PORT} --env production"

