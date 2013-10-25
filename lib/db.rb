require 'mongoid'

Mongoid.load!("conf/mongoid.yaml", :development)

require './lib/db/github_repo'
