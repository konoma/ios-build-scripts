#!/usr/bin/env ruby

require 'fileutils'


## Helpers

class Plist
  def initialize(path)
    @plist_path = path
  end
  
  def set(key, value)
    self.exec(
      "/usr/libexec/PlistBuddy -c \"Set :#{key} #{value}\" \"#{@plist_path}\"",
      "/usr/libexec/PlistBuddy -c \"Add :#{key} string #{value}\" \"#{@plist_path}\""
    )
  end
  
  def add(key, type, value)
    self.exec()
  end
  
  def exec(command, fallback_command)
    unless system(command)
      unless system(fallback_command)
        puts "Command #{command} failed"
        exit 1
      end
    end
  end
end


## Setup

INFO_PLIST = Plist.new('${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app/Info.plist')
DSYM_PLIST = Plist.new('${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app.dSYM/Contents/Info.plist')


## Actions

def set_bundle_version(version)
  if version.nil?
    puts 'No version given'
    exit 1
  end
  
  INFO_PLIST.set('CFBundleVersion', version.strip)
  DSYM_PLIST.set('CFBundleVersion', version.strip)
end


## Main

ACTION = ARGV.shift

if ACTION.nil?
  puts 'Error: No action given'
  exit 1
end


case ACTION
  when 'set-bundle-version' then set_bundle_version(ARGV.shift)
  
  else
    puts "Error: Unknown action #{ACTION}"
    exit 1
end
