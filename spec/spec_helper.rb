require 'rspec'
require 'yaml'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

require File.join(File.dirname(__FILE__), '../lib/cocoapods')
require File.join(File.dirname(__FILE__), '../lib/fetcher')


def save_object(obj)
  File.open('/tmp/__rbobj.yaml', 'w') do |f|
    f.write YAML.dump(obj)
  end
end

def load_object(path)
  File.open(path, 'r') do |f|
    return YAML.load f.read()
  end
  obj
end