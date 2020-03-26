require 'yaml'
file = YAML::load(File.open('game_info.yml'))

puts file