#!/usr/bin/env ruby

require './lib/db'
require './lib/db/github_repo'

ObjCToolBox::Db::GithubRepo.all.each do |r|
  puts "#{r.pod_name}\thttps://github.com/#{r.owner}/#{r.name}/\t#{r.watch}\t#{r.fork}\t#{r.network}\t#{r.issue}\t#{r.updated_at}"
end
