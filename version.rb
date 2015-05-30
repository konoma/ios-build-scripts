#!/usr/bin/env ruby


## Actions - Converting Version Numbers

def fetch_commit_hash_list()
  `git rev-list --all --reverse`.strip.split(/\n/)
end

def get_version(hash)
  if hash.upcase == 'HEAD'
     hash = `git rev-parse HEAD`.strip
  end
  
  hash_list = fetch_commit_hash_list()
  version = hash_list.find_index(hash)
  
  if version.nil?
    puts 'Error: Not a commit hash'
    exit 1
  end
  
  puts "#{version + 1}"
end

def get_hash(version)
  hash_list = fetch_commit_hash_list()
  version_number = version.to_i
  
  if version_number.nil? or version_number < 1 or version_number > hash_list.count
    puts 'Error: Not a version number'
    exit 1
  end
  
  puts "#{hash_list[version_number - 1]}"
end


## Main

ACTION = ARGV.shift
VERSION_OR_HASH = ARGV.shift

if ACTION.nil?
  puts 'Error: No action given'
  exit 1
end

if VERSION_OR_HASH.nil?
  puts 'Error: No verson/hash given'
  exit 1
end

case ACTION
  when 'get-version' then get_version(VERSION_OR_HASH)
  when 'get-hash' then get_hash(VERSION_OR_HASH)
  
  else
    puts "Error: Unknown action #{ACTION}"
    exit 1
end