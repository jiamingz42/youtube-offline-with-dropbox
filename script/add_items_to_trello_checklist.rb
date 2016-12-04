require 'optparse'
require 'awesome_print'
require 'yaml'
require 'trello'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  opts.on("-c", "--config CONFIGURATION", "Path to the configuration YAML file") do |c|
    options[:config] = c
  end
  
end.parse!

def main(options)
  unless options[:config]
    raise StandardError, 'No configuration file is specified'
  end

  config = YAML.load(File.open(options[:config], 'r'))
  puts 'CONFIGURATION'
  ap config

  print "\nDo you want to continue? (y/N): "
  user_response = gets.strip
  return if user_response != 'y'

  card = Trello::Card.find(config['card_id'])

  config['checklists'].each do |checklist_data|
    checklist_name = checklist_data['name']
    checklist_id = JSON.parse(card.create_new_checklist(checklist_name))['id']
    checklist = Trello::Checklist.find(checklist_id)
    checklist_data['items'].each do |item|
      checklist.add_item(item)
    end
  end
end

# Usage
#   ruby [filename] --c config.yaml
main(options)


